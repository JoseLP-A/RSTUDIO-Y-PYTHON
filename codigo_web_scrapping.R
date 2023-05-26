
# Comparto mi codigo para extraer información del "Speedtest Global Index" publicado por Ookla, 
# usando web scrapping para automatizar el proceso  

# Speedtest Global Index: https://www.speedtest.net/global-index


# Imporatmos las librerias a usar
#--------------------------------

library(dplyr)
library(rvest)
library(foreign)


# Url de la pagina
url <- "https://www.speedtest.net/global-index"
pagina <- read_html(url)

# Extraemos los link de paises
links <- html_attr(html_nodes(pagina, "a"), "href")

# Lo guardamos en un dataframe 
df=as.data.frame(as.character(links))

# Nos quedamos con los paises y el servicio fijo y movil.

links_fijo <- df  %>% 
  filter(!grepl("?city", as.character(links)) & grepl("/global-index/", as.character(links)) & grepl("fixed", as.character(links)))

links_mobile <- df  %>% 
  filter(!grepl("?city", as.character(links)) & grepl("/global-index/", as.character(links)) & grepl("mobile", as.character(links)))


# Extraemos los datos que necesitamos
# =====================================


#----------------------
# INTERNET MOVIL
#----------------------


int_mobil  <- NULL

for(i in 1:nrow(links_mobile)) {
  
  page_website <- paste0('https://www.speedtest.net', links_mobile[i,])
  pagina_2 <- read_html(page_website)
  
  # descarga
  mobil_descarga <- pagina_2 %>% 
    html_nodes("#column-mobileMedian .download .number") %>%  html_text
  
  # Subida 
  mobil_subida <- pagina_2 %>% 
    html_nodes("#column-mobileMedian .upload .number") %>%  html_text
 
  # latencia 
  mobil_latencia <- pagina_2 %>% 
    html_nodes("#column-mobileMedian .latency .number") %>%  html_text
  
  int_mobil <- rbind(int_mobil, c(links_mobile[i,], mobil_descarga, mobil_subida, mobil_latencia))
  
}

df_int_mobil <- data.frame(int_mobil)


#----------------------
# INTERNET FIJO
#----------------------

int_fijo  <- NULL

for(i in 1:nrow(links_fijo)) {
  
  page_website <- paste0('https://www.speedtest.net', links_fijo[i,])
  pagina_2 <- read_html(page_website)
  
  # Ranking 
  fijo_ranking <- pagina_2 %>% 
    html_nodes("#column-fixedMedian .rank .number") %>%  html_text
  
  # descarga
  fijo_descarga <- pagina_2 %>% 
    html_nodes("#column-fixedMedian .download .number") %>%  html_text
  
  # Subida 
  fijo_subida <- pagina_2 %>% 
    html_nodes("#column-fixedMedian .upload .number") %>%  html_text
  
  
  # latencia 
  fijo_latencia <- pagina_2 %>% 
    html_nodes("#column-fixedMedian .latency .number") %>%  html_text
  
  int_fijo <- rbind(int_fijo, c( links_fijo[i,], fijo_ranking, fijo_descarga, fijo_subida, fijo_latencia))
}

df_int_fijo <- data.frame(int_fijo)


# Guardamos las bases
save(internet_ookla_2 , file = "internet_ookla.RData")
saveRDS(internet_ookla_2, "internet_ookla.rds")

# Exportamos a formato DTA

write.dta(df_int_mobil,"C:/Users/jleiva/Desktop/bases/df_int_mobil.dta")
write.dta(df_int_fijo,"C:/Users/jleiva/Desktop/bases/df_int_fijo.dta")


#*************************** FIN :D



