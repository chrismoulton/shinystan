# This file is part of shinystan
# Copyright (C) Jonah Gabry
#
# shinystan is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
# 
# shinystan is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <http://www.gnu.org/licenses/>.

# options(shiny.trace=TRUE)
object <- get(".shinystan_temp_object", envir = shinystan:::.sso_env)
source("global_utils.R", local = TRUE)
source(file.path("server_files","utilities","extract_sso.R"), local=TRUE)

# Begin shinyServer -------------------------------------------------------
# _________________________________________________________________________
function(input, output, session) {
  
  # Stop the app when "Quit" button is clicked
  observe({
    if (input$save_and_close_button > 0) 
      stopApp(object)
  })
  # source all files from server_files directory and subdirectories
  files <- list.files("server_files", full.names = TRUE, recursive = TRUE)
  for (f in files) source(f, local = TRUE)

  options_inputs <- c("table", "multiparam", "autocorr", "rhat_warnings", # multitrace
                      "bivariate", "trivariate", "density", "hist")
  dens_inputs <- c("point_est", "ci", "x_breaks", "fill_color", "line_color")
  observe({
    lapply(seq_along(options_inputs), function(j){
      shinyjs::onclick(paste0(options_inputs[j], "_options_show"),
                       shinyjs::toggle(id = paste0(options_inputs[j], "_options"), 
                                       anim = TRUE, animType = "slide", time = 0.4))
    })
    lapply(seq_along(dens_inputs), function(j) {
      shinyjs::toggleState(id = paste0("dens_", dens_inputs[j]), 
                           condition = input$dens_chain_split == "Together")
    })
    shinyjs::toggleState(id = "ac_flip", condition = input$ac_combine == FALSE)
  })
  observe({
    toc_entries <- c("Estimate", "Diagnose", "Explore", "Model Code")
    local({
      lapply(toc_entries, function(x) {
        id <- paste0("toc_", if (x == "Model Code") "more" else tolower(x))
        shinyjs::onclick(id, updateTabsetPanel(session, "nav", selected = x))
       })
    })
    shinyjs::onclick("open_glossary_from_table",
                     updateTabsetPanel(session, "nav", selected = "Glossary"))
    shinyjs::onclick("open_glossary_from_nuts_table", 
                     updateTabsetPanel(session, "nav", selected = "Glossary"))
#     shinyjs::onclick("open_glossary_from_rhat", 
#                      updateTabsetPanel(session, "nav", selected = "Glossary"))
  })
  observeEvent(input$open_quick_rhat, 
               shinyjs::info(includeText("text/quick_rhat.txt")))
  observeEvent(input$open_quick_neff, 
               shinyjs::info(includeText("text/quick_neff.txt")))
  observeEvent(input$open_quick_mcse, 
               shinyjs::info(includeText("text/quick_mcse.txt")))
  
  
  diagnostic_inputs <- paste0("diagnostic_", 
                             c("param", "param_transform", "param_transform_go"))
  observe({
    diag_nav <- input$diagnostics_navlist
    local({
      if (diag_nav != 'By model parameter')
        lapply(diagnostic_inputs, function(x) shinyjs::disable(id = x))
      else 
        lapply(diagnostic_inputs, function(x) shinyjs::enable(id = x))
    })
  })
  
  observeEvent(input$shinystan_citation_show,
               shinyjs::toggle(id = "citation_div", anim = TRUE, animType = "fade"))
  
} # End server

