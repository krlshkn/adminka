import { Container, DateField, TextField } from "@material-ui/core";
import { useEffect, useState } from "react";

export default function Acc(){
    
    if(sessionStorage.getItem("role")=="guest" || sessionStorage.getItem("role")==="админ") window.location.replace("*");
    const [records, setRecords]=useState([]);
    const [orders, setOrders]=useState([]);
    const[programs, setPrograms] = useState([]);
    const[products, setProducts] = useState([]);

    const id = sessionStorage.getItem("id");
    useEffect(()=>{
                fetch("http://localhost:8080/userrecords/"+id)
                .then(res=>res.json())
                .then((result)=>{
                    setRecords(result);
                }
                )
                console.log(records);
                fetch("http://localhost:8080/userorders/"+id)
                .then(res=>res.json())
                .then((result)=>{
                    setOrders(result);
                }
                )
                fetch("http://localhost:8080/getprograms")
                .then(res=>res.json())
                .then((result)=>{
                    setPrograms(result);
                }
                )
                fetch("http://localhost:8080/getallproducts")
                .then(res=>res.json())
                .then((result)=>{
                    setProducts(result);
                }
                )
                
            }, []);

                
                const enter=(e)=>{
                    e.preventDefault()
                    sessionStorage.clear();
                    window.location.replace("/login");
                }
    return(
        <Container>
              <button onClick={enter}>выход</button>
            <div className="recs">
          <h5>  Мои записи</h5>
        {records.map(record=>(
            
            <div className="record_card_one" key = {record.id}>      
            {programs.map(program =>(sessionStorage.setItem(`pro${program.id}`, program.name)))} 
                {/* <option id="max" value={sessionStorage.getItem("programmax")}>{sessionStorage.getItem("programmax")}</option> */}
                          
            <p className="recordp">{record.date}&nbsp;&nbsp;&nbsp;{record.time}:00 &nbsp;&nbsp;&nbsp;{sessionStorage.getItem(`pro${record.program}`)}</p>
            {/* <button onClick={()=>deleteClick(record.id)}> Удалить</button> */}
            </div>
        ))}
        </div>
        <div className="ords">
       <h5 id="free"> Мои заказы</h5>
        {orders.map(order=>(
            <div className="record_card_one"  key = {order.id}>
                                {products.map(product =>(sessionStorage.setItem(`prod${product.id}`, product.name)))} 

            <p className="recordp">{order.date}&nbsp;&nbsp;&nbsp;{sessionStorage.getItem(`prod${order.product}`)}&nbsp;&nbsp;&nbsp;{order.status}</p>
            {/* <button onClick={()=>deleteClick(record.id)}> Удалить</button> */}
             </div>
        ))}
        </div>
    
    </Container>

    )

}