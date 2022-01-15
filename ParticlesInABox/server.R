#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output) {
  dt = 0.005
  kVac <- 9 * 10**9
  e <- 1.602 * 10**-19
  mass <- 9.109 * 10**-31
  
  

  observeEvent(
    eventExpr = input[["goButton"]],
    handlerExpr = {
      print("Running Simulation")
      output$gif <- renderImage({
          speed_Vec <- rnorm(input$n, mean = input$speed, sd = input$speed_Std)
          xVelPer <- runif(input$n, 0, 1)
          accX <- rep.int(0, input$n)
          accY <- rep.int(0, input$n)
          xPos <- runif(input$n, .1 * input$BoxW, .9 * input$BoxW)
          yPos <- runif(input$n, .1 * input$BoxH, .9 * input$BoxH)
          xDir <- sample(c(-1,1), input$n, replace = TRUE)
          yDir <- sample(c(-1,1), input$n, replace = TRUE)
          particles_Start <- data.frame(speed_Vec, xVelPer, xPos, yPos, xDir, yDir, accX, accY)
          

          particles_Start %>%
            mutate(xVel = (speed_Vec * xVelPer)* xDir) %>%
            mutate(yVel = (speed_Vec * (1 - xVelPer))* yDir) -> partsInMotion
          i = 0
          j = 1
          
          while (i <= input$totalTime) {
            
            for (k in 1:nrow(partsInMotion)){
              ax = 0
              ay = 0
              for (m in 1:nrow(partsInMotion)){
                if (k != m){
                  theta = atan((partsInMotion[m, "yPos"] - partsInMotion[k, "yPos"])/
                                 (partsInMotion[m, "xPos"] - partsInMotion[k, "xPos"]))
                  fx = kVac * (e)^2 * cos(theta) /((partsInMotion[m, "xPos"] - partsInMotion[k, "xPos"])^2 -
                                                   (partsInMotion[m, "yPos"] - partsInMotion[k, "yPos"])^2)
                  fy = kVac * (e)^2 * sin(theta) /((partsInMotion[m, "xPos"] - partsInMotion[k, "xPos"])^2 -
                                                   (partsInMotion[m, "yPos"] - partsInMotion[k, "yPos"])^2)
                  if (partsInMotion[m, "yPos"] > partsInMotion[k, "yPos"]){
                    fy = fy * -1
                  }
                  if (partsInMotion[m, "xPos"] > partsInMotion[k, "xPos"]){
                    fx = fx * -1
                  }
                  ax = ax + fx/mass
                  ay = ay + fy/mass
                }
              }
              partsInMotion[k, "accX"] = ax + partsInMotion[k, "accX"]
              partsInMotion[k, "accY"] = ay + partsInMotion[k, "accX"]
            }
            partsInMotion %>%
              # If too close to wall they bounce by changing the velocity direction
              mutate(xVel = ifelse(
                xPos <= .005 * input$BoxW | xPos >= .995 * input$BoxW, 
                xVel * -1,
                xVel)) %>%
              mutate(yVel = ifelse(
                yPos <= .005 * input$BoxH | yPos >= .995 * input$BoxH, 
                yVel * -1,
                yVel)) %>%
              mutate(xPos = xPos + (xVel + accX * dt) * dt) %>%
              mutate(yPos = yPos + (yVel + accY * dt) * dt) -> partsInMotion
            
            if (j %% 5 == 0){ 
  print(partsInMotion)
            mypath <- file.path("C:", "Users", "jmeis", "Projects", "ParticleBox",
                                "images", paste("motion_", formatC(j, width = 5, flag="0"), ".jpg", sep = ""))
            myTitle <- paste("T = ", i, "seconds", sep = " ")
            g <- ggplot(partsInMotion, aes(x = xPos, y = yPos))
            motionPlot <- g + geom_point() +
              geom_hline(yintercept = 0) +
              geom_hline(yintercept = input$BoxH) +
              geom_vline(xintercept = 0) +
              geom_vline(xintercept = input$BoxW) +
              xlim(0, input$BoxW) +
              ylim(0, input$BoxH) +
              labs(
                title = myTitle
              )
            motionPlot
            ggsave(mypath, dpi = "screen")
            }
            i = i + dt
            j = j + 1
          }
          #move output statement here
          jpegs <- list.files(file.path("C:", "Users", "jmeis", "Projects", "ParticleBox",
                                        "images"),
                              pattern = "\\.jpg$",
                              recursive = FALSE,
                              all.files = FALSE,
                              full.names = TRUE)
          jpegs %>%
            map(image_read) %>% # reads each path file
            image_join() %>% # joins image
            image_animate(fps = 5) %>% # animates
            image_write(file.path("C:", "Users", "jmeis", "Projects", "ParticleBox","All_plots.gif"))
          list(src= file.path("C:", "Users", "jmeis", "Projects", "ParticleBox","All_plots.gif") )
      }, deleteFile = TRUE
      )
    }
  )
}

     
    
      



    


