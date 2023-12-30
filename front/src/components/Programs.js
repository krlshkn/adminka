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
                    sessionStorage.setItem("programname", program.name);
                    sessionStorage.setItem("programpic", program.picture);
                    sessionStorage.setItem("programprice", program.price);
                    sessionStorage.setItem("programhours", program.hours);
                    sessionStorage.setItem("programmin", program.minmembers);
                    sessionStorage.setItem("programmax", program.maxmembers);
                    sessionStorage.setItem("programdescription", program.description);
                    // sessionStorage.setItem(`prigram+${program.id}`. program.name);
                    // console.log(sessionStorage.getItem("programid"));
                    }}>
                        <div key={program.id}>
                        
                            <label>
                        {program.name}<br></br>
                        <img src={program.picture}></img>
                        <div className="product_title">
                        {program.minmembers}-{program.maxmembers} человек<br></br>
                        {program.hours} часа<br></br>
                        по расписанию
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