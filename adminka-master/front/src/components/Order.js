import { useEffect, useState } from "react";
import {Container}  from '@material-ui/core';

export default function Order(){
    const [order, setOrder]=useState('');
    const[arr, setValue]=useState([]);
    const[products, setProducts]=useState([]);

    if(sessionStorage.getItem("role")==null || sessionStorage.getItem("role")=="гость"){
        alert("Вы не авторизовались, нажмите на смайлик");
        window.location.replace("/products")
    }
    for(var i=0; ; i++){
        if(sessionStorage.getItem(`productid+${i}`)==null) {
            //sessionStorage.clear();
            break;}

        else arr.push(sessionStorage.getItem(`productid+${i}`));
    }
    console.log(arr);

    const handleClick=(e)=>{
        e.preventDefault()
        var products = arr.values();
        var customer = Number(sessionStorage.getItem("id"));
        for(let product of products){
            fetch("http://localhost:8080/addorder/"+customer+"/"+product,{
                method:"POST",
                headers:{"Content-Type":"application/json"},
                body:JSON.stringify()
        })
        .then(()=>{
            console.log("order added");
        }
        )
        }    
}
var name = "productname+0";
var price = "productprice+0";
    console.log(products.filter(product => arr.includes(product.id)))
// filter(product=>(arr.includes(product.id)))
    return(
        <Container>
        <div>
            <h1>заказ</h1>
            <div>
                <p>{JSON.parse(sessionStorage.getItem("productid1"))}</p>
                В вашем заказе есть
                <p>{sessionStorage.getItem(name)}</p>
                          <button id="order_button" onClick={handleClick}>подтвердить заказ</button>

            </div>
            
        </div>    
        </Container>
    )


}
    
