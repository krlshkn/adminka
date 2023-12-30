import { useEffect, useState } from "react";
import {Container}  from '@material-ui/core';

export default function Order(){
    const [order, setOrder]=useState('');
    const[arr, setValue]=useState([]);
    const[products, setProducts]=useState([]);

    for(var i=0; ; i++){
        if(sessionStorage.getItem(`productid+${i}`)==null) {
            //sessionStorage.clear();
            break;}

        else arr.push(sessionStorage.getItem(`productid+${i}`));
    }
    console.log(arr);
    const date = new Date();

    const handleClick=(e)=>{
        e.preventDefault()
        var products = arr.values();
        var status = "принят";
        var customer = new Number(sessionStorage.getItem("id"));
        for(let product of products){
            const order={date, status, customer, product};
            fetch("http://localhost:8080/addorder",{
                method:"POST",
                headers:{"Content-Type":"application/json"},
                body:JSON.stringify(order)
        })
        .then(()=>{
            console.log("order added");
        }
        )
        }    
}
    console.log(products.filter(product => arr.includes(product.id)))
// filter(product=>(arr.includes(product.id)))
    return(
        <Container>
        <div>
            <h1>заказ</h1>
            <div>
                {/* <p>{JSON.parse(sessionStorage.getItem("productid1"))}</p> */}
                          <button id="order_button" onClick={handleClick}>оформить заказ</button>

            </div>
            
        </div>    
        </Container>
    )


}
    
