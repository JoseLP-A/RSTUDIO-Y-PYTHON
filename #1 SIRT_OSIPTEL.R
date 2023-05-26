/* 
Comparto mi sintaxis para extraer informacion del sistema de consultas tarifarias (SIRT) del OSIPTEL,
de esta formas se puede extraer información de este portal sin necesidad de hacerlo manualmente
*/



# Cargamos las librerias a usar
# =============================

library(dplyr)
library(tidyr)
library(stringr)
library(rvest)
library(readxl)
library(data.table)


# Directorio de nuestra base
# ==========================

setwd("C:/Users/XXXX/Desktop/web_scrap")

names <- data.frame(list.files(pattern="*.xlsx"))

# La direccion donde lo archivos que genere el codigo web scrapping seran guardados
a <- "C:/Users/XXXX/Desktop/web_scrap/data_scrap"

# --------------------------------
                                                                                           
for (x in 1:nrow(names)){

  sirt <- NULL
  
  base_1 <- read_excel(paste0(names[x,]))
  string <- paste0(names[x,])
  
  base_1 <- base_1 %>% select("DETALLE FICHA INFORMATIVA")
  
  for(i in 1:nrow(base_1)) {
    
      url = paste0(base_1[i,])
      download.file(url, destfile = "page_website.html", quiet=TRUE)
  
      #page_website <- paste0(base_1[i,])
      
      pagina_2 <- read_html("page_website.html")
      
      # Nombre Empresa
      name_empresa <- pagina_2 %>%
        html_nodes("#IdlblEmpresa") %>% html_text()
      
      # Nomnbre del plan
      name_plan <- pagina_2 %>%
        html_nodes("#IdlblNombre") %>% html_text()
      
      # CARACTERISTICAS ESPECIFICAS
      
      # valor del plan
      valor_plan <- pagina_2 %>%
        html_nodes("#lblDValPlan") %>% html_text()
      
      #-----------------------------------
      # Servicio 1: "Tlf movil"
      # =================================
      
      tipo_serv1 <- pagina_2 %>%
        html_nodes("#Label1") %>% html_text()
      
      # valor del servicio
      valor_serv1 <- pagina_2 %>%
        html_nodes("#lblTMValPlan") %>% html_text()
      
      # Saldo disponible
      saldo_disp <- pagina_2 %>%
        html_nodes("#lblDSaldDispMov") %>% html_text()
      
      # Mensaje de txto a cualquier destino
      msje_txt <- pagina_2 %>%
        html_nodes("#lblDMensTextMov") %>% html_text()
      
      # Tarifa On net
      tarif_on_net <- pagina_2 %>%
        html_nodes("#lblDSaldOnMov") %>% html_text()
     
      # Tarifa Off net
      tarif_off_net <- pagina_2 %>%
        html_nodes("#lblDSaldOffMov") %>% html_text()
      
      # Tarif adic tlf fijos
      tarif_adic_tlf_fijo <- pagina_2 %>%
        html_nodes("#lblDSaldTfMov") %>% html_text()
      
      # Minutos red privada
      min_red_priv <- pagina_2 %>%
        html_nodes("#lblMinRedPri") %>% html_text()
      
      # Minutos todo destino
      min_todo_dest <- pagina_2 %>%
        html_nodes("#lblTMMINTODODEST") %>% html_text()
      
      #------------------------------------------
      # Servicio 7: "Telefonia fija"
      # =================================
      
      tipo_serv7 <- pagina_2 %>%
        html_nodes("#Label7") %>% html_text()
      
      # valor del servicio
      valor_serv7 <- pagina_2 %>%
        html_nodes("#lblTFValPlan") %>% html_text()
      
      # Tiempo incluido
      tiemp_incluido <- pagina_2 %>%
        html_nodes("#lblDCantFijInc") %>% html_text()
      
      # Minutos multidestino
      min_multi <- pagina_2 %>%
        html_nodes("#lblDBolsaMult") %>% html_text()
      
      
      #----------------------------
      # Servicio 2: "Cable"
      # =================================
      
      tipo_serv2 <- pagina_2 %>%
        html_nodes("#Label2") %>% html_text()
      
      # valor del servicio
      valor_serv2 <- pagina_2 %>%
        html_nodes("#lblCABValPlan") %>% html_text()
      
      # Número de canales de video
      num_canales <- pagina_2 %>%
        html_nodes("#lblDNumCanCab") %>% html_text()
      
      # Número de canales de video HD
      num_canaleshd <- pagina_2 %>%
        html_nodes("#lblCanVidAltDef") %>% html_text()
      
      #-----------------------------------------------
      # Servicio 3: "Internet"
      # =================================
      
      
      tipo_serv3 <- pagina_2 %>%
        html_nodes("#Label3") %>% html_text()
      
      
      # Valor del servicio
      valor_serv3 <- pagina_2 %>%
        html_nodes("#lblINTValPlan") %>% html_text()
      
      # Velocidad máxima contratada
      vel_max_contratada <- pagina_2 %>%
        html_nodes("#lblDVelMaxInt") %>% html_text()
      
      # Velocidad de descarga mínima garantizada
      vel_dec_min_garanti <- pagina_2 %>%
        html_nodes("#lblDVelMinInt") %>% html_text()
      
      # Cantidad de datos de transmisión
      cant_datos_trans <- pagina_2 %>%
        html_nodes("#lblDDescargInt") %>% html_text()
      
      # Tecnología de la velocidad máxima
      tecn_vel_max <- pagina_2 %>%
        html_nodes("#lblTecVelMax") %>% html_text()
      
      sirt <- rbind(sirt, c(base_1[i,],
                            "Nombre de la empresa" = name_empresa,
                            "Nombre del plan" = name_plan,
                            "Valor del plan" = valor_plan,
                            
                            "Servicio 1" = tipo_serv1,
                            "Valor del servicio 1" = valor_serv1,
                            "Saldo disponible" = saldo_disp,
                            "Msje de texto a cualquier destino" =msje_txt,
                            "Tarifa ON NET" = tarif_on_net,
                            "Tarifa OFF NET" = tarif_off_net,
                            "Tarifa adicional tlf fijo"=tarif_adic_tlf_fijo,
                            "Minutos red privada"=min_red_priv,
                            "Minutos todo destino"=min_todo_dest,
                            
                            "Servicio 7" = tipo_serv7,
                            "Valor del servicio 7" = valor_serv7,
                            "Tiempo incluido" = tiemp_incluido,
                            "Minutos multidestino" = min_multi,
                            
                            "Servicio 2" = tipo_serv2,
                            "valor del servicio 2" = valor_serv2,
                            "Numero de canales" = num_canales,
                            "Numero de canales HD" = num_canaleshd,
                            
                            
                            "Servicio 3" = tipo_serv3,
                            "valor del servicio 3" = valor_serv3,
                            "Velocidad maxima contratada" = vel_max_contratada,
                            "velocidad minima garantizada" = vel_dec_min_garanti,
                            "cantidad datos trans" = cant_datos_trans,
                            "teconologia velocidad maxima" = tecn_vel_max))
      
      # Nos permite ver el proceso
      print(paste(i, "de", nrow(base_1)))
      
      }    

  df_sirt <- data.frame(sirt)
  
  #Los siguientes dos "print" tienen que ser iguales, de esa forma 
  # nos aseguramos que todos los links han sido leidos
  
  print(nrow(base_1))
  print(nrow(df_sirt))
 
  #Exportamos en formato .CSV
  b <- sub(".xlsx", ".csv", string)
  file.path(a,b)
  
  fwrite(df_sirt, file = file.path(a,b))

}  


# FIN ......................:D


