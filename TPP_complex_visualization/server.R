library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library(ggsci)

combine2 <- read.csv("RNase_control_shiny.csv", stringsAsFactors = FALSE)
cplot <- function(df, complexname, p_r_max, p_r_min, filcolumn){
    #filter dataframe based on parameter
    filterdf <- filter(df, id == complexname & R_sq_Control <= p_r_max & R_sq_Control >= p_r_min & 
                           Protein_ID %in% filcolumn)
    # create datafram for scatter plot 
    mat <- filterdf %>% select(contains("norm_rel_fc"))
    mat$protein <- filterdf$Protein_ID
    names <- as.numeric(c(37, 39.7, 43, 45.1, 48.3, 52.4, 57.9, 62.1, 65.1, 67))
    colnames(mat) <- names
    dff <- cbind(mat[11], stack(mat[1:10]))
    colnames(dff) <- c('Protein', 'values', 'ind')
    dff$ind <- as.numeric(as.character(dff$ind))
    # create dataframe for line plot 
    linedf <- select(filterdf, a_Control, b_Control, plateau_Control)
    rownames(linedf) <-filterdf$Protein_ID
    linemat <- matrix(ncol= length(seq(37,67, by=1)) , nrow=nrow(linedf))
    for (i in 1:nrow(linedf)){
        a = linedf[i,1]
        b = linedf[i,2]
        p = linedf[i,3]
        fun <- function(x){(1-p)/(1+exp(-(a/x-b)))+p} 
        linemat[i,] = fun(seq(37, 67, by=1))
    }
    colnames(linemat) <- seq(37, 67, by =1)
    rownames(linemat) <- rownames(linedf)
    linedff <- cbind(rownames(linemat), stack(as.data.frame(linemat)))
    colnames(linedff) <- c('Protein', 'values', 'ind')
    linedff$ind <- as.numeric(as.character(linedff$ind))
    # plot 
    ggplot() + 
        geom_point(data = dff, mapping = aes(x = ind, y = values, color= Protein), size = 0.75) + 
        geom_line(data = linedff, aes(x=ind, y=values, color = Protein)) +
        xlab("Temperature (°C)") + ylab("Soluble Fraction") + ggtitle(complexname) +
        scale_x_continuous(breaks = seq(37, 67, by = 5)) +
        scale_color_npg()
}

cdf <- function(df, complexname, p_r_max, p_r_min, filcolumn){
    filterdf <- filter(df, id == complexname & R_sq_Control <= p_r_max & R_sq_Control >= p_r_min &
                           Protein_ID %in% filcolumn) 
    mat <- filterdf %>% select(contains("norm_rel_fc"))
    names <- c('37°C', '39.7°C', '43°C', '45.1°C', '48.3°C', '52.4°C', '57.9°C', '62.1°C', '65.1°C', '67°C')
    colnames(mat) <- names
    df <- select(filterdf, a_Control, b_Control, plateau_Control, R_sq_Control)
    rownames(df) <-filterdf$Protein_ID
    colnames(df) <- c("a", "b", "p", "R_sq")
    df_1 <- cbind(mat, df)
    Protein <- filterdf$Protein_ID
    df_1 <- cbind(Protein, df_1)
    df_1
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    complexupdate <- reactive({
        req(input$complex_p)
        filter(combine2, p_adj <= input$complex_p[2] & p_adj >= input$complex_p[1])
    })
    observeEvent(complexupdate(), {
        choices <- unique(complexupdate()$id)
        #freezeReactiveValue(input, "complexInput")
        updateSelectInput(inputId = "complexInput", choices = choices, selected =  ) 
    })
    proteinupdate <- reactive({
        req(input$protein_p, input$complexInput)
        filter(complexupdate(), R_sq_Control <= input$protein_p[2] & 
                   R_sq_Control >=input$protein_p[1] & id == input$complexInput)
    })
    observeEvent(proteinupdate(), {
        choices <- unique(proteinupdate()$Protein_ID)
        #freezeReactiveValue(input, "proteinInput")
        updateCheckboxGroupInput(inputId = "proteinInput", choices = choices, selected = choices) 
    })
    output$coolplot <- renderPlot({
        cplot(combine2, input$complexInput, input$protein_p[2], input$protein_p[1], input$proteinInput)
    })
    output$pvalue <- renderText({
        paste0("p_adj: ", signif(unique(filter(combine2, id == input$complexInput)$p_adj),2))
    })
    output$results <- renderDataTable({
        cdf(combine2, input$complexInput , input$protein_p[2], input$protein_p[1], input$proteinInput)
    })
        
    output$p_download <- downloadHandler(
        filename = function() {
            paste(input$complexInput,'.png',sep='')
        },
        content = function(file) {
            ggsave(file, 
                   plot = cplot(combine2, input$complexInput, 
                                input$protein_p[2], input$protein_p[1], input$proteinInput))
        }
    )
    

})
