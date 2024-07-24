library(dplyr)
library(tidytext)
library(tidyr)
library(readr)
library(stringr)

# Function to read the first 1000 lines from a text file
read_first_3000_lines <- function(file_path) {
  read_lines(file_path, n_max = 3000)
}

# Paths to your text files
file_paths <- c("~/Desktop/Research/Dr. Raghavendra/Coursera/Data Science Capstone/final/en_US/en_US.blogs.txt", "~/Desktop/Research/Dr. Raghavendra/Coursera/Data Science Capstone/final/en_US/en_US.news.txt", "~/Desktop/Research/Dr. Raghavendra/Coursera/Data Science Capstone/final/en_US/en_US.twitter.txt")

# Read the first 1000 lines from each file
text_corpus <- lapply(file_paths, read_first_3000_lines) %>%
  unlist()

# Create a data frame from the text corpus
text_df <- data.frame(text = text_corpus, stringsAsFactors = FALSE)

# Clean and preprocess the text data
text_df <- text_df %>%
  mutate(text = tolower(text)) %>%
  mutate(text = str_replace_all(text, "[^a-z\\s]", ""))

# Create bigrams, trigrams, and quadgrams
bigrams <- text_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
  separate(bigram, into = c("word1", "word2"), sep = " ") %>%
  count(word1, word2, sort = TRUE) %>%
  filter(n > 1)

trigrams <- text_df %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3) %>%
  separate(trigram, into = c("word1", "word2", "word3"), sep = " ") %>%
  count(word1, word2, word3, sort = TRUE) %>%
  filter(n > 1)

quadgrams <- text_df %>%
  unnest_tokens(quadgram, text, token = "ngrams", n = 4) %>%
  separate(quadgram, into = c("word1", "word2", "word3", "word4"), sep = " ") %>%
  count(word1, word2, word3, word4, sort = TRUE) %>%
  filter(n > 1)

# Save the n-gram models
saveRDS(bigrams, "bigrams.rds")
saveRDS(trigrams, "trigrams.rds")
saveRDS(quadgrams, "quadgrams.rds")
