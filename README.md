# TPP_protein-complex-visualization

### Short description 
#### 
TPP protein complex visualization is a webapp built with shiny. The main purpose of this app is to visualize the protein complex from TPP experiment.
<br>![alt text](https://github.com/yam020/TPP_protein-complex-visualization/blob/main/output/Overall.png)

Users are able to select protein complex based on melting curve similarity (Complex: Adjusted p value). Protieins within protein complex can be selected based on their R square of the cruve fit (Protein: R sq). Proteins can be further selected by user's input. 
Plot on the right will then reflect these input.
<br>![alt text](https://github.com/yam020/TPP_protein-complex-visualization/blob/main/output/Plot%20area.png)

Table below the plot contains normalized relative protein-fold changes of selected proteins. Table also contains the parameters and the coefficient of determination R^2 of the fitted melting curve of each selected protien.
<br>![alt text](https://github.com/yam020/TPP_protein-complex-visualization/blob/main/output/Table%20area.png)

This webapp also allows download of generated plot.
<br>![alt text](https://github.com/yam020/TPP_protein-complex-visualization/blob/main/output/BBS-chaperonin%20complex.png)


### Getting started  
#### 
Step 1: clone the repo using the command line
```bash
$ git clone "https://github.com/yam020/TPP_protein-complex-visualization.git"
```
Step 2: open an R session and install shiny package 
```bash
install.packages("shiny")
```
Step 3: run the app 
```bash
library(shiny)
runApp("/path/to/my/directory/TPP_protein-complex-visualization")
```
