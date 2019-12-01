library(sf); library(ggplot2); library(wesanderson)


curbs <- st_read('F:/GIS/curblines/curblines.shp') # https://www.opendataphilly.org/dataset/curb-edges

colPal <- wes_palette('Moonrise3', n = 5) # Make a color palette of 5 colors from Moonrise Kingdom using wesanderson pkg
preferredProj <- '+proj=lcc +lat_1=39.93333333333333 +lat_2=40.96666666666667 +lat_0=39.33333333333334 +lon_0=-77.75 +x_0=600000 +y_0=0 +datum=NAD83 +units=us-ft +no_defs'
curbs <- st_transform(curbs, crs = preferredProj) 



# # This code snippet below makes a circular map. But we're going to do a rectangular one instead
# circleCenter <- data.frame(lat = 39.931808, lng = -75.164205) # centroid
# circleCenter <- circleCenter %>%
#   st_as_sf(coords = c('lng', 'lat')) %>%
#   st_set_crs(4326) %>%
#   st_transform(crs = preferredProj)
# circleOutline <- st_buffer(circleCenter, dist = 1213) # 370m (or 1213ft) radius buffer
# 
# curbsCircle <- st_intersection(curbs, circleOutline)
# 
# # randomly assign a color from the color palette above to each of the polygons
# curbsCircle$polyCol <- colPal[sample(1:length(colPal), nrow(curbsCircle), replace = T)]
# 
# # pdf(file="H:/passyunkPrint.pdf", width=10, height=10)
# p <- ggplot() +
#   geom_sf(data = circleOutline, fill = 'black', col = 'white') +
#   geom_sf(data = curbsCircle, aes(fill = polyCol), col = 'black') +
#   geom_sf(data = circleOutline, fill = NA, col = 'white', lwd = 2)
# p + scale_fill_manual(values = colPal) +
#   theme(legend.position = 'none',
#         panel.background = element_blank(),
#         panel.grid = element_blank(),
#         axis.text = element_blank(),
#         axis.ticks = element_blank())
# # dev.off()



squareOutline <- rbind(c(-75.168418, 39.934431), # top left
                       c(-75.161191, 39.934431), # top right
                       c(-75.161191, 39.928730), # bottom right
                       c(-75.168418, 39.928730), # bottom left
                       c(-75.168418, 39.934431)) 

squareOutline <- squareOutline %>%
  list() %>%
  st_polygon() %>%
  st_geometry() %>%
  st_set_crs(4326) %>%
  st_transform(crs = st_crs(curbs))

curbsSquare <- st_intersection(curbs, squareOutline)


# randomly assign a color from the color palette above to each of the polygons
curbsSquare$polyCol <- colPal[sample(1:length(colPal), nrow(curbsSquare), replace = T)]

# pdf(file="H:/passyunkSquare.pdf", width=10, height=10)
p <- ggplot() +
  geom_sf(data = squareOutline, fill = 'black', col = 'white') +
  geom_sf(data = curbsSquare, aes(fill = polyCol), col = 'black') + 
  geom_sf(data = squareOutline, fill = NA, col = 'white', lwd = 2)
p + scale_fill_manual(values = colPal) +
  theme(legend.position = 'none',
        panel.background = element_blank(),
        panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())
# dev.off()

