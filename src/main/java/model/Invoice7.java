package model;

import java.util.Date;
import java.util.ArrayList;

/** Lớp Invoice7 trong biểu đồ lớp thiết kế CineMan. */
public class Invoice7 {
    private int id;
    private Date createdTime;
    private double totalAmount;
    private ArrayList<Ticket7> tickets = new ArrayList<>();
    private Customer7 customer;
    private SalesStaff7 salesStaff;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Date createdTime) {
        this.createdTime = createdTime;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public ArrayList<Ticket7> getTickets() {
        return tickets;
    }

    public void setTickets(ArrayList<Ticket7> tickets) {
        this.tickets = tickets;
    }

    public Customer7 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer7 customer) {
        this.customer = customer;
    }

    public SalesStaff7 getSalesStaff() {
        return salesStaff;
    }

    public void setSalesStaff(SalesStaff7 salesStaff) {
        this.salesStaff = salesStaff;
    }
}
