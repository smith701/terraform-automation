
customername=$1

sed s/customername/$customername/g backened.template > backened.tf

cp -avr backened.tf  /root/practice/


#sed command repalce the value of $customername in the backened.template 

#copy the backened.template to backened.tf inside the practice folder

#sed command replace the validate of $customer name in the variable.template

#copy the variables.template file inside the pracktice folder 

cd  /root/practice


terraform destroy -force




