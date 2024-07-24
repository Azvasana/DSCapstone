library(shiny)
library(dplyr)

# Load the n-gram models
bigrams <- readRDS("bigrams.rds")
trigrams <- readRDS("trigrams.rds")
quadgrams <- readRDS("quadgrams.rds")

# Function to predict the next words using quadgrams, trigrams, and bigrams
predict_next_words <- function(phrase, num_words) {
  words <- unlist(strsplit(phrase, " "))
  predictions <- character()
  
  for (i in 1:num_words) {
    last_word <- tail(words, 1)
    last_two_words <- tail(words, 2)
    last_three_words <- tail(words, 3)
    
    quadgram_next_word <- quadgrams %>%
      filter(word1 == last_three_words[1], word2 == last_three_words[2], word3 == last_three_words[3]) %>%
      top_n(1, wt = n) %>%
      pull(word4)
    
    trigram_next_word <- trigrams %>%
      filter(word1 == last_two_words[1], word2 == last_two_words[2]) %>%
      top_n(1, wt = n) %>%
      pull(word3)
    
    bigram_next_word <- bigrams %>%
      filter(word1 == last_word) %>%
      top_n(1, wt = n) %>%
      pull(word2)
    
    next_word <- if (length(quadgram_next_word) > 0) {
      quadgram_next_word
    } else if (length(trigram_next_word) > 0) {
      trigram_next_word
    } else if (length(bigram_next_word) > 0) {
      bigram_next_word
    } else {
      "No prediction available"
    }
    
    if (next_word == "No prediction available") {
      break
    } else {
      words <- c(words, next_word)
      predictions <- c(predictions, next_word)
    }
  }
  
  predictions
}

server <- function(input, output, session) {
  # Reactive value to store prediction history
  history <- reactiveVal(data.frame(Phrase = character(), Prediction = character(), stringsAsFactors = FALSE))
  
  observeEvent(input$predict, {
    phrase <- input$phrase
    num_words <- input$num_predictions
    next_words <- predict_next_words(phrase, num_words)
    
    # Update prediction history
    new_entry <- data.frame(Phrase = phrase, Prediction = paste(next_words, collapse = " "), stringsAsFactors = FALSE)
    updated_history <- rbind(history(), new_entry)
    history(updated_history)
    
    output$prediction <- renderText({ paste(next_words, collapse = " ") })
    output$history <- renderUI({
      tagList(
        lapply(1:nrow(updated_history), function(i) {
          p(paste0(updated_history$Phrase[i], " -> ", updated_history$Prediction[i]))
        })
      )
    })
    
    # Create frequent predictions table
    freq_data <- updated_history %>%
      unnest_tokens(word, Prediction) %>%
      count(word, sort = TRUE)
    
    output$freq_table <- renderTable({
      freq_data
    })
  })
}

shinyApp(ui = ui, server = server)
