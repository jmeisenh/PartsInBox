#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(gapminder)
library(gganimate)
library(gifski)
library(magick)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Particles In a Box"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            numericInput(
              inputId = "n",
              label = "Number of particles",
              value = 50,
              min = 0,
              max = 500,
              step = 1),
            # numericInput(
            #   inputId = "e",
            #   label = "Charge of Particles in Columbs",
            #   value = 1.602 * 10**-19,
            #   min = .1,
            #   max = 1.0,
            #   step = .1),
            # numericInput(
            #   inputId = "mass",
            #   label = "Mass of Particles in Kg",
            #   value = 9.109 * 10**-31,
            #   min = .1,
            #   max = 1.0,
            #   step = .1),
           numericInput(
             inputId = "speed",
             label = "Average Speed of Particles in m/s",
             value = 1,
             min = 0,
             max = 5,
             step = 0.1),
           numericInput(
             inputId = "speed_Std",
             label = "Standard Deviation of Speed of Particles in m/s",
             value = 0.5,
             min = 0,
             max = 1,
             step = 0.1),
           numericInput(
             inputId = "BoxW",
             label = "With of box in m",
             value = 2,
             min = .1,
             max = 20,
             step = 0.1),
           numericInput(
             inputId = "BoxH",
             label = "Height of box in m",
             value = 2,
             min = .1,
             max = 20,
             step = 0.1),
           numericInput(
             inputId = "totalTime",
             label = "Duration of simulation in s",
             value = 2,
             min = 1,
             max = 10,
             step = 0.5),
           actionButton(
             inputId = "goButton",
             label = "Run!",
             class = "btn-success")
            
                    ),

        # Show a plot of the generated distribution
        mainPanel(
            imageOutput(outputId = "gif")
        )
    )
))
