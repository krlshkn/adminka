package com.mypottery.pottery.repo;

import com.mypottery.pottery.model.Worker;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WorkerRepository extends JpaRepository<Worker, Integer> {
}