import {Container}  from '@material-ui/core';
import { useEffect, useState } from "react";
import $ from 'jquery';

export default function Programs(){
    const[programs, setPrograms]=useState([]);

    useEffect(()=>{
        fetch("http://localhost:8080/getprograms")
        .then(res=>res.json())
        .then((result)=>{
            setPrograms(result);
        }
        )
    }, [])


    return(
        <Container>
        <div>
            <h1>программы</h1>
            <div>
                {programs.map(program=>(
                    <form action='/record'>
                    <button  className="product_card" onClick={()=> {sessionStorage.setItem("programid", program.id);
                    sessionStorage.setItem("programname", program.title);
                    sessionStorage.setItem("programpic", program.picture);
                    sessionStorage.setItem("programprice", program.price);
                    sessionStorage.setItem("programmax", program.maxMembers);
                    sessionStorage.setItem("programdescription", program.description);
                    // sessionStorage.setItem(`prigram+${program.id}`. program.name);
                    // console.log(sessionStorage.getItem("programid"));
                    }}>
                        <div key={program.id}>
                        
                            <label>
                        {program.title}<br></br>
                        <img src="https://thumb.tildacdn.com/tild3133-3766-4162-b565-623961386530/-/format/webp/2_700700.jpg" alt = ""></img>
                        <div className="product_title">
                        максимум участников - {program.maxMembers}<br></br>
                        </div>
                        </label>
                        
                        {/* <input className="input_class" type="checkbox" name={program.name} id={program.id}  src={program.picture} placeholder={program.type} readOnly={program.price}></input> */}
                        {/* <input className="input_class" type="checkbox" name="check_program" id={program.id} ></input> */}
                        </div>
                        </button>
                        </form>

                ))}
            </div>
           {/* <a href="/order"><button id="order_button" onClick={orderButton}>оформить заказ</button></a> */}
           {/* <button id="order_button" onClick={orderButton}>оформить заказ</button> */}
            
        </div>    
        </Container>
    )
}