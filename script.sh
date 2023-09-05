#!/bin/bash

echo " Est ce que voulez vous ajouter ou créer une machine ??"
echo " Taper (y/Y) si voulez vous créer  "
echo "Ou bien (n/N) si vous ne voulez pas " 
read boolMachine


while [[ $boolMachine != "n" && $boolMachine != "N" && $boolMachine != "y"  &&  $boolMachine != "Y" ]];
do 
echo "Vous avez mal taper la commande , je repete ma question ?? Est ce que voulez vous ajouter ou créer une machine ??? "
echo "Taper (y/Y) si voulez vous créer "
echo "Ou bien (n/N) si vous ne voulez pas " 
read boolMachine
done


if [[ $boolMachine=="y" || $boolMachine=="Y" ]];then 

             while [[ $boolMachine == 'y' || $boolMachine == 'Y' ]];
             do
              echo "Vous trouvez la liste des groupe qu'elle existe déja :  " 
               az group list --output table 
              echo "  Enter the Resource Group name: " 
              read ResourceGroupName
              echo "  Enter the location (i.e. centralus):"
              echo " (  eastus=East US                   ,  eastus2=East US 2  ,"
              echo " southcentralus=South Central US     ,  westus2=West US 2 ,"
              echo " westus3=West US 3                   ,  australiaeast= Australia East  ,"
              echo " swedencentral=Sweden Central        ,  uksouth=UK South  ,"
              echo "  westeurope=West Europe             ,  centralus=Central US ,"
              echo " southafricanorth=South Africa North , centralindia=Central India ,"
              echo " eastasia=East Asia                  , japaneast=Japan East ,"
              echo " koreacentral=Korea Central          ,  canadacentral=Canada Central ,"
              echo " francecentral=France Central        ,  germanywestcentral=Germany West Central  ,"
              echo "  norwayeast=Norway East             ,  polandcentral=Poland Central  ,"
              echo " brazilsouth=Brazil South            ,  qatarcentral=Qatar Central ,"
              echo " centralusstage=USA Centre           ,  northcentralusstage=USA Centre Nord ," 
              echo " southcentralusstage=USA Centre Sud  ,  eastusstage=USA Est   , "
              echo " jioindiawest=Jio India West         ,  westcentralus=West Central US ," 
              echo " southafricawest=South Africa West   , australiacentral=Australia Central ,"  
              echo "australiacentral2=Australia Central 2,   australiasoutheast=Australia Southeast  ,"  
              echo " japanwest=Japan West                ,   jioindiacentral=Jio India Central    ," 
              echo " koreasouth=Korea South              ,    southindia=South India    ," 
              echo " westindia=West India                ,  canadaeast=Canada East    ,"   
              echo " norwaywest=Norway West              ,   switzerlandwest=Switzerland West ," 
              echo " centraluseuap                       ,    eastus2euap," 
              echo " eastusstg                           ,   northcentralus,"
              echo " southcentralusstg                   ,   westus,"
              echo " eastasia                            ,   switzerlandnorth,"
              echo " japaneast                           ,   uaenorth,"  
              read location 


         if [[ $(az group exists --name $ResourceGroupName) == "false" ]]; then
                           az group create --name $ResourceGroupName --location $location
                           echo " Ce groupe est etais bien créer"

                       else 
                            az group show --name $ResourceGroupName 
                            echo "Ce group Existe " 

                       fi

echo " Enter the virtual machine name (used for generating resource names):  " 
read NameVM

echo " Enter the administrator username: " 
read username 
echo ""
echo "Vous trouvez ici la liste des images de la machine virtuel : "

az vm image list --output table 

echo "Enter le nom de L'image que vous voulez crée pour votre machine virtuel:  " 
read image

echo "Vous trouvez toute la liste des reséaux  "
az network vnet list 

echo " Vous trouvez la liste de reséau de Groupe $ResourceGroupName  "
az network vnet list $ResourceGroupName


echo " Entrer  le nom de Reseau "
read VnetName

echo " Entrer  le nom de sous-Reseau  "
read subVnetName

echo " c'est les sous réseau $subVnetName  de Groupe  $ResourceGroupName  :"
az network vnet show -g $ResourceGroupName -n $subVnetName

echo " Donner le nom de l'adresse IP fournie "
read NameIp


echo "Donner la zone de l'adresse IP 1 , 2 ou 3 " 
read zoneIp

while [[ $zoneIp -ne 1 &&  $zoneIp -ne 2 && $zoneIp -ne 3 ]];
do 
echo " il faut taper la zone de l'adresse IP : 1 - 2 ou 3 "
read zoneIp
done

az network public-ip create --name $NameIp --resource-group $ResourceGroupName --zone $zoneIp
echo   " Enter le nom  de la clé ssh   "
read  KeyName


az network vnet create --name $VnetName --resource-group $ResourceGroupName --subnet-name $subVnetName --location $location
az vm create --name $NameVM --resource-group $ResourceGroupName --image $image --admin-username $username --size Standard_B1s --vnet-name $subVnetName --ssh-key-name $KeyName --generate-ssh-keys


echo "   Est ce que voulez vous ajouter ou créer  une autre  machine ??  "
echo "  Taper (y/Y) si voulez vous créer "
echo " Ou bien (n/N) si vous ne voulez pas " 
read boolMachine
done
else
exit 3
fi


