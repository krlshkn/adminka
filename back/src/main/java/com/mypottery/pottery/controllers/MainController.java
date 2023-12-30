package com.mypottery.pottery.controllers;

import com.mypottery.pottery.model.*;
import com.mypottery.pottery.model.Record;
import com.mypottery.pottery.repo.*;
import com.mypottery.pottery.service.AuthorizationService;
import com.mypottery.pottery.service.MainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
public class MainController {

    @Autowired
    private MainService mainService;
    @Autowired
    private AuthorizationService authorizationService;
    @Autowired
    private RecordRepo recordRepo;
    @Autowired
    private CustomerRepo customerRepo;
    @Autowired
    private OrderRepo orderRepo;
    @Autowired
    private ProductRepo productRepo;
    @Autowired
    private ProgramRepo programRepo;

//добавление
    @PostMapping("/addproduct")
    public String addProduct(@RequestBody Product product){ productRepo.save(product); return "New product added";}

    @PostMapping("/addorder")
    public String createOrder(@RequestBody Order order ){ orderRepo.save(order); return "New order added";}

    @PostMapping("/addrecord")
    public String addRecord(@RequestBody Record record ){ recordRepo.save(record); return "New record added";}

    @PostMapping("/adduser/{name}/{login}/{pwd}/{phonenumber}")
    public String addUser(@PathVariable("name") String name,@PathVariable("login") String login, @PathVariable("pwd") String pwd, @PathVariable("phonenumber") String phonenumber)
                         { Customer c = new Customer(); c.setName(name); c.setLogin(login); c.setPwd(pwd); c.setRole("user"); c.setPhonenumber(phonenumber); c.setStatus("действ");
                           customerRepo.save(c); return "New user added";}

//изменение
    @PutMapping("/updaterecord/{id}/{user}/{status}")
    public String updateRecord(@PathVariable("id") int id, @PathVariable("user") int user, @PathVariable("status") int status){ mainService.updateRecord(id, user, status);return "Record updated";}

    @PutMapping("/updateuser/{id}/{status}")
    public String updateUser(@PathVariable("id") int id, @PathVariable("status") String status){ mainService.updateUser(id, status);return "User updated";}

    @PutMapping("/updateorder/{id}/{status}")
    public String updateOrder(@PathVariable("id") int id, @PathVariable("status") String status){
        mainService.updateOrder(id, status);return "Order updated";
    }


//чтение
    @GetMapping("/finduser/{login}/{pwd}")
    public List<Customer> findUser(@PathVariable("login") String login, @PathVariable("pwd") String pwd){return authorizationService.findUser(login, pwd);}

    @GetMapping("/user/{id}")
    public String getUser(@PathVariable("id") int id){ return customerRepo.findById(id).orElseThrow().toString();}

    @GetMapping("/getusers")
    public List<Customer> getUsers(){return customerRepo.findAll();}

    @GetMapping("/record/{id}")
    public List<Record> getRecord(@PathVariable("id") int id){ return mainService.findByProgram(id);}

    @GetMapping("/getrecords")
    public List<Record> getRecords(){return recordRepo.findAll();}

    @GetMapping("/futurerecords")
    public List<Record> getFutureRecords(){return mainService.findFutureRecords();}

    @GetMapping("/freerecords")
    public List<Record> getFreeRecords(){return mainService.findFreeRecords();}

    @GetMapping("/userrecords/{id}")
    public List<Record> getUserRecords(@PathVariable("id") int id){ return recordRepo.findByCustomerId(id);}

    @GetMapping("/userorders/{id}")
    public List<Order> getUserOrders(@PathVariable("id") int id){
        return orderRepo.findByCustomerId(id);
    }

    @GetMapping("/userlogin/{id}")
    public String getUserLogin(@PathVariable("id") int id){ return customerRepo.findById(id).orElseThrow().getLogin();}

    @GetMapping("/getprograms")
    public List<Program> getAllPrograms(){return programRepo.findAll();}

    @GetMapping("/getorders")
    public List<Order> getAllOrders(){return orderRepo.findAll();}

    @GetMapping("/getallproducts")
    public List<Product> getAllProducts(){return productRepo.findAll();}

    @GetMapping("/getproduct/{id}")
    public String getProduct(@PathVariable("id") int id){ return productRepo.findById(id).orElseThrow().toString();}

    @GetMapping("/programname/{id}")
    public String getProgramName(@PathVariable("id") int id){ return programRepo.findById(id).orElseThrow().getTitle();}

    @GetMapping("/getprogrambyname/{name}")
    public int getProgramByName(@PathVariable("name") String name){ return mainService.findProgramByName(name);}


//удаление
    @DeleteMapping("/deleterecord/{id}")
    public void deleteRecord(@PathVariable("id") int id){ recordRepo.deleteById(id);;}

}