

library(dplyr)
library(rvest)


url <- "https://www.speedtest.net/global-index"

pagina <- read_html(url)



links <- html_attr(html_nodes(pagina, "a"), "href")


df=as.data.frame(as.character(links))
df



links_global <- df  %>% 
  filter(!grepl("?city", as.character(links)) & grepl("/global-index/", as.character(links)) & grepl("fixed", as.character(links)))

links_fijo <- df  %>% 
  filter(!grepl("?city", as.character(links)) & grepl("/global-index/", as.character(links)) & grepl("fixed", as.character(links)))


links_mobile <- df  %>% 
  filter(!grepl("?city", as.character(links)) & grepl("/global-index/", as.character(links)) & grepl("mobile", as.character(links)))


#----------------------
## Mobil
#----------------------

#Ranking
pagina_2 %>% 
  html_nodes("#column-mobileMedian .rank .number") %>%  html_text

# descarga
pagina_2 %>% 
  html_nodes("#column-mobileMedian .download .number") %>%  html_text


# upload 

pagina_2 %>% 
  html_nodes("#column-mobileMedian .upload .number") %>%  html_text


# latencia 
pagina_2 %>% 
  html_nodes("#column-mobileMedian .latency .number") %>%  html_text


##  Fijo
#----------------------

#Ranking
pagina_2 %>% 
  html_nodes("#column-fixedMedian .rank .number") %>%  html_text

# descarga
pagina_2 %>% 
  html_nodes("#column-fixedMedian .download .number") %>%  html_text


# upload 

pagina_2 %>% 
  html_nodes("#column-fixedMedian .upload .number") %>%  html_text


# latencia 
pagina_2 %>% 
  html_nodes("#column-fixedMedian .latency .number") %>%  html_text



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

library(foreign)
write.dta(df_int_mobil,"C:/Users/jleiva/Desktop/bases/df_int_mobil.dta")

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


# RENAME NOMBRES 
df_int_fijo <- rename(df_int_fijo, Link=X1,
       ranking=X2,
       descarga=X3,
       subida=X4,
       latencia=X5)


#SPLIT STRING
library(stringr)
df_int_fijo2 <- cbind(df_int_fijo, str_split_fixed(df_int_fijo$Link, "/",3))

df_int_fijo2 <- cbind(df_int_fijo2, str_split_fixed(df_int_fijo2$"3","#",3))

df_int_fijo2 <- subset(df_int_fijo2, select = -c(1, 2,3, 2,3))


write.dta(df_int_fijo,"C:/Users/jleiva/Desktop/bases/df_int_fijo.dta")



save(internet_ookla_2 , file = "internet_ookla.RData")

saveRDS(internet_ookla_2, "internet_ookla.rds")
