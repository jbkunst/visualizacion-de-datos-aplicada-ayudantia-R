# parameters --------------------------------------------------------------
PARS <- list(
  color_main       =  "#ab6a47",
  # color_main       =  "#47475C",
  color_background = "#FFFAFA", # snow white
  color_light_gray = "#D3D3D3", # pale gray

  # https://www.quora.com/What-is-the-best-font-color-for-text-on-a-grey-background-screen
  # Dark Charcoal
  color_text       = "#333333",

  font_header      = "Alegreya Sans SC",
  font_main        = "IBM Plex Sans",
  font_code        = "Fira Mono"
)

# scales::show_col(PARS$color_main)

# try(meta <- rmarkdown::metadata)
#
# if(exists("meta")){
#   # meta <- list(subtitle = "99 formato test <code><small>dplyr tidyr</small></code>")
#
#   fig_path <- meta$subtitle |>
#     stringr::str_to_lower() |>
#     stringr::str_replace_all("\\s+", "-") |>
#     # https://stackoverflow.com/a/34344957/829971
#     rvest::read_html() |>
#     rvest::html_text()
#
#   fig_path <- file.path("images", fig_path, "knitr-img-")
#
#   # knitr::opts_chunk$set(fig.path = "images/99-formato-test/knitr-img-")
#   knitr::opts_chunk$set(fig.path = fig_path)
#
# }


# knitr -------------------------------------------------------------------
knitr::opts_chunk$set(
  dev = "svg",

  # fig.width = 9,
  # fig.height = 3.5,

  # full size with title
  fig.width = 11,
  fig.height = 5,

  fig.retina = 3,
  out.width = "100%",

  cache = FALSE,

  echo = TRUE,

  message = FALSE,
  warning = FALSE,
  hiline = TRUE

)

# xaringanthemer ----------------------------------------------------------
# suppressWarnings(dir.create("slides/css"))

xaringanthemer::style_mono_accent(
  base_color       = PARS$color_main,
  background_color = PARS$color_background,
  text_color       = PARS$color_text,

  header_font_google = xaringanthemer::google_font(PARS$font_header, 100),
  text_font_google   = xaringanthemer::google_font(PARS$font_main),
  code_font_google   = xaringanthemer::google_font(PARS$font_code),

  text_font_size = "1.2rem", # 1rem default
  # base_font_size = "24px", # default is 20px
  # header_h1_font_size = "2.0rem", # "2.75rem",
  # header_h3_font_size = "1.5rem", # "2.75rem",

  link_decoration = stringr::str_glue("{PARS$color_light_gray} wavy underline"),

  # title_slide_background_image = "hans_bbc.png",
  # extra_css = list(),
  # extra_fonts = list(),

  outfile = here::here("docs/css/xaringan-themer.css")
)

# xaringanExtra -----------------------------------------------------------
options(htmltools.dir.version = FALSE)
xaringanExtra::use_scribble(pen_color = PARS$color_main) # press S
xaringanExtra::use_tile_view()                      # press O
xaringanExtra::use_webcam()                         # press W
xaringanExtra::use_animate_all("fade")
xaringanExtra::use_freezeframe() # for GIFs!
xaringanExtra::use_progress_bar(color = "red", location = "bottom", height = "30px")

# ggplot2 -----------------------------------------------------------------
# library(showtext)

sysfonts::font_add_google(PARS$font_main, "font_main")
showtext::showtext_auto()

ggplot2::theme_set(
  ggplot2::theme_minimal(
    base_family = "font_main"
    # base_size   = 12

    # base_size       = 10,
    # axis_title_size = 8,
    # plot_margin     = ggplot2::margin(10, 10, 10, 10),

    # plot_title_face = "plain",
    # subtitle_face = "plain"
  ) +
    ggplot2::theme(
      plot.title       = ggplot2::element_text(face = "plain"),
      plot.background  = ggplot2::element_rect(fill = PARS$color_background, colour = NA),
      panel.background = ggplot2::element_rect(fill = PARS$color_background, colour = NA),

      # hrbrthemes::theme_ipsum
      # b = 0, l = 0, m = 0.5, c = 0.5, r = 1, t = 1
      axis.title.x     = ggplot2::element_text(hjust = 1),
      axis.title.y     = ggplot2::element_text(hjust = 1),
      # plot.margin      = ggplot2::margin(30, 30, 30, 30),

      legend.key.width = ggplot2::unit(1.5, "cm"),
      legend.position = "bottom"

    )
)

scale_fill_pres_c <- function(option = "C", begin = 0.05, end = 0.85, ...) {
  ggplot2::scale_fill_viridis_c(option = option, begin = begin, end = end, ...)
}

scale_fill_pres_d <- function(option = "C", begin = 0.05, end = 0.85, ...) {
  ggplot2::scale_fill_viridis_d(option = option, begin = begin, end = end, ...)
}

scale_color_pres_c <- function(option = "C", begin = 0.05, end = 0.85, ...) {
  ggplot2::scale_color_viridis_c(option = option, begin = begin, end = end, ...)
}

scale_color_pres_d <- function(option = "C", begin = 0.05, end = 0.85, ...) {
  ggplot2::scale_color_viridis_d(option = option, begin = begin, end = end, ...)
}

