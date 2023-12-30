import {Container}  from '@material-ui/core';
import { useEffect, useState } from "react";
import $ from 'jquery';

export default function Product(){
    const[products, setProducts]=useState([]);
    const[order, setOrder]=useState('');

    useEffect(()=>{
        fetch("http://localhost:8080/getallproducts")
        .then(res=>res.json())
        .then((result)=>{
            setProducts(result);
        }
        )
    }, [])

    function orderButton(){
        //if(sessionStorage.getItem("role"!="guest")){
        var i = 0;
        $('input').each(function() {
            if(this.checked){
                sessionStorage.setItem(`productid+${i}`, this.id);
                sessionStorage.setItem(`producttype+${i}`, this.placeholder);
                sessionStorage.setItem(`productname+${i}`, this.name);
                sessionStorage.setItem(`productprice+${i}`, this.readOnly);
                sessionStorage.setItem(`productpicture+${i}`, this.src);
                i+=1;
            }
          })
        window.location.replace("/order")//}
          //else alert("Вы не зарегистрированы! Нажмите на смайлик и авторизуйтесь")
    }

    return(
        <Container>
        <div>
            <h1>заказать</h1>
            <div>
                {products.map(product=>(
                        <div className="product_card" key={product.id}>
                        <label for={product.id}>
                        <img src={product.picture}></img>
                        <div className="product_title">
                        {product.type}<br></br>
                        "{product.name}"<br></br>
                        размер: {product.length} * {product.width} * {product.height}<br></br>
                        цена: {product.price} руб
                        </div>
                        </label>
                        <input className="input_class" type="checkbox" name={product.name} id={product.id}  src={product.picture} placeholder={product.type} readOnly={product.price}></input>
                        {/* <input className="input_class" type="checkbox" name="check_product" id={product.id} ></input> */}
                        </div>

                ))}
            </div>
           {/* <a href="/order"><button id="order_button" onClick={orderButton}>оформить заказ</button></a> */}
           <button id="order_button" onClick={orderButton}>оформить заказ</button>
            
        </div>    
        </Container>
    )
}