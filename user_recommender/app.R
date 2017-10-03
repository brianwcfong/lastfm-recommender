#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Artist Recommendation Engine"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput("select_userid", "User ID:",
                     choices = unique_users)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tableOutput('usertable'),
        tableOutput('xtable')
         
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$xtable <- renderTable({
      # Generate list of 10 recommended artists
      x <- predict(rec.model,female.real[input$select_userid,],n=10)
      
      x2 <- as.data.frame(as(x,"list"))
      colnames(x2) <- "artistid"
      x2 <- merge(x2,unique_artists, all.x=TRUE,by.x="artistid", by.y="artistid")
      x2$artistid <- NULL
      as.data.frame(x2)
   }
   ,caption = "Recommended Artists")
   
   # Generate list of most listened to artists for user
   output$usertable <- renderTable({
     x <- female %>% filter(userid == input$select_userid) %>% select(artist,plays) %>% head(10)
     x[order(-x$plays),]
   }
   ,caption = "Most listened artists by Play Count")
}

# Run the application 
shinyApp(ui = ui, server = server)

