# NOTAS PARA PRODUCCIÓN

## DOMINIOS
- clubemprendedor.tk:
  - Contratado en [Freenom](https://my.freenom.com/)
  - Apuntado a [DigitalOcean](https://cloud.digitalocean.com/networking/domains/clubemprendedor.tk)
  - Dominio agregado en Heroku
  ```
  heroku domains:add clubemprendedor.tk
  heroku domains:add www.clubemprendedor.tk
  ```
    - Usando este dominio no se puede navegar con SSL porque el certificado es de para \*.herokuapp.com.
    - Si se contrata un servicio pago se va a poder navegar con SSL, porque se puede solicitar un certificado para todos los dominios custom gratis:
    ```
    heroku certs:auto
    ```
