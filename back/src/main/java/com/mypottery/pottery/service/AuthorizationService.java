package com.mypottery.pottery.service;

import com.mypottery.pottery.model.Customer;
import com.mypottery.pottery.repo.CustomerRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthorizationService {
    @Autowired
    private CustomerRepo customerRepo;

//    public Customer findUser(String login, String pwd) {
//        Customer c = customerRepo.findByLogin(login);
//        if (c != null && c.getPwd().equals(pwd)) return c;
//        return customerRepo.findByRole("guest");
//    }
    public List<Customer> findUser(String login, String pwd) {
        List<Customer> cus = customerRepo.findByLogin(login);
        for(Customer c: cus){
        if (c != null && c.getPwd().equals(pwd)) return cus;}
        return customerRepo.findByRole("guest");
    }

    public boolean checkLogin(String login) {
        List<Customer> c = customerRepo.findByLogin(login);
        if (c != null) return true;
        return false;
    }
}
