package com.mypottery.pottery.service;

import com.mypottery.pottery.model.Customer;
import com.mypottery.pottery.model.Order;
import com.mypottery.pottery.model.Program;
import com.mypottery.pottery.model.Record;
import com.mypottery.pottery.repo.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MainService {

    @Autowired
    private ProductRepo productRepo;

    @Autowired
    private OrderRepo orderRepo;

    @Autowired
    private ProgramRepo programRepo;

    @Autowired
    private RecordRepo recordRepo;

    @Autowired
    private CustomerRepo customerRepo;

    @Autowired
    private AccountRepository accountRepository;

    public List<Record> findByProgram(int program){
        List<Record> recs= recordRepo.findAll();;
        List<Record> filterrecs = recs.stream()
                .filter(r -> r.getProgram().getId() == program)
                .toList();
        return filterrecs;
    }

    public void updateRecord(int id, int user, int status){
        Record okRecord = recordRepo.findRecordById(id);
//        okRecord.setStatus(status);
        okRecord.setCustomer(accountRepository.getReferenceById(user));
//        okRecord.setCustomer(user);
        recordRepo.save(okRecord);
    }
    public void updateOrder(int id, String status){
        Order okOrder = orderRepo.findOrderById(id);
        okOrder.setStatus(status);
        orderRepo.save(okOrder);
    }
    public void updateUser(int id, String status){
        Customer okCustomer = customerRepo.findUserById(id);
        okCustomer.setStatus(status);
        customerRepo.save(okCustomer);
    }
    public List<Record> findFutureRecords(){
        List<Record> recs = recordRepo.findAll();
        List<Record> future = recs.stream()
//                .filter(r -> r.getStatus()==0)
                .toList();
        return future;
    }
    public List<Record> findFreeRecords(){
        List<Record> recs = recordRepo.findAll();
        List<Record> future = recs.stream()
//                .filter(r -> r.getStatus()==1)
                .toList();
        return future;
    }
    public int findProgramByName(String name){
        Program p = programRepo.findByTitle(name);
        return p.getId();
    }

}
