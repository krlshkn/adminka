import { Container, DateField, TextField } from "@material-ui/core";
import { useEffect, useState } from "react";
export default function ProductAdmin(){

    var [orders, setOrders]=useState([]);
    var[product, setProduct]=useState();
    var[login, setLogin]=useState();
    var[status, setStatus] = useState();
    const[programs, setPrograms] = useState([]);
    const[users, setUsers] = useState([]);

    useEffect(()=>{
                fetch("http://localhost:8080/getorders")
                .then(res=>res.json())
                .then((result)=>{
                    setOrders(result);
                }
                )
                fetch("http://localhost:8080/getallproducts")
                .then(res=>res.json())
                .then((result)=>{
                    setPrograms(result);
                }
                )
                fetch("http://localhost:8080/getusers")
                .then(res=>res.json())
                .then((result)=>{
                    setUsers(result);
                }
                )
                
            }, [])
  
                
                const updateOrder=(orderid)=>{
                    var order = new Number(orderid);                    
                    fetch("http://localhost:8080/updateorder/"+order+"/"+status,{
                        method:"PUT",
                        headers:{"Content-Type":"application/json"},
                        body:JSON.stringify(order) 
                    })
                    .then(()=>{
                        console.log("record put added");
                        window.location.reload();
                    }
                    )
                    }    
    return(
        <Container>
           <h1> список заказов</h1>
        {orders.map(order=>(
            <div className="order_card_one" key = {order.id}>    
             {programs.map(program =>(sessionStorage.setItem(`pr${program.id}`, program.name)))}     
                   {users.map(user =>(sessionStorage.setItem(`us${user.id}`, user.login)))}  
            {order.id}&nbsp;&nbsp;&nbsp;{order.date} &nbsp;&nbsp;&nbsp;{sessionStorage.getItem(`pr${order.product}`)}&nbsp;&nbsp;&nbsp;{sessionStorage.getItem(`us${order.customer}`)}
                <p className="recordp"></p>
                <TextField id = {order.id} label={order.status} variant="outlined"  onChange={(e)=>setStatus(e.target.value)}/>
            <button onClick={()=>(updateOrder(order.id))}>обновить</button>
                  
 </div>
        ))}
       
    </Container>

    )

}