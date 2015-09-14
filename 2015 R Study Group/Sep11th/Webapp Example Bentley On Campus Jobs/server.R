library(shiny)

shinyServer(function(input, output) {
    library(scrapeR)
    library(dplyr)
    url = "http://www.bentley.edu/files/feeds/student-employment/academic_year_bydept.html"
    parsedPage <- scrape(url)
    tableNodes <- getNodeSet(parsedPage[[1]], "//table")
    njobs <- length(tableNodes)
    Departments <- JobTitles <- Supervisors <- CC <- LevelReq <- Hours <- SalaryRange <- vector()
    for (i in 1:njobs){
        t <- readHTMLTable(tableNodes[[i]],stringsAsFactors = FALSE)
        Departments <- c(Departments, strsplit(t[1,1],": ")[[1]][2])
        JobTitles <- c(JobTitles, strsplit(t[2,1],": ")[[1]][2])
        Supervisors <- c(Supervisors, strsplit(t[3,1],": ")[[1]][2])
        Hours <- c(Hours, strsplit(t[4,1],": ")[[1]][2])
        CC <- c(CC, strsplit(t[1,2],": ")[[1]][2])
        LevelReq <- c(LevelReq, strsplit(t[2,2],": ")[[1]][2])
        SalaryRange <- c(SalaryRange,strsplit(t[2,3],": ")[[1]][2])}
    df <- cbind.data.frame(Departments,JobTitles,Supervisors,Hours,CC,LevelReq,SalaryRange, stringsAsFactors = F)
    df$Date <- format(Sys.Date(), "%d %m %Y")
    df <- arrange(df, Date, LevelReq, JobTitles)

    output$table <- renderTable({
        df
    })
})