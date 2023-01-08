#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library(ggsci)

df <- read.csv("RNase_control_shiny.csv", stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application theme
    theme = bslib::bs_theme(bootswatch = "sandstone"),
    
    # Application title
    titlePanel("TPP Visualization_Protein Complex"),

    # Sidebar with a slider input
    sidebarLayout(
        sidebarPanel(
            sliderInput("complex_p", "Complex: Adjusted p value", min = 0, max = 1,
                        value = c(0, 0.05)),
            selectInput("complexInput", "Complex",
                        choices = NULL),
                        #choices = unique(filter(df, p_adj < 0.1)$id), 
                        #selected = "BBS-chaperonin complex"),
            sliderInput("protein_p", "Protein: R sq", min = 0, max = 1,
                        value = c(0.8, 1)),
            checkboxGroupInput("proteinInput", "Protein", 
                               choices = NULL),
                               #choices = filter(combine2, id == "BBS-chaperonin complex")$Protein_ID,
                               #selected = filter(combine2, id == "BBS-chaperonin complex")$Protein_ID)
            downloadButton("p_download" ,class = "btn-primary")
        ),

        # Show a plot and a table 
        mainPanel(
            plotOutput("coolplot"),
            br(), 
            textOutput("pvalue"),
            br(), br(),
            dataTableOutput("results")
        )
    )
))
