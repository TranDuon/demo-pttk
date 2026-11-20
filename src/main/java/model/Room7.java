package model;

import java.util.ArrayList;

/** Lớp Room7 trong biểu đồ lớp thiết kế CineMan. */
public class Room7 {
    private int id;
    private String name;
    private int capacity;
    private ArrayList<Seat7> seats = new ArrayList<>();

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public ArrayList<Seat7> getSeats() {
        return seats;
    }

    public void setSeats(ArrayList<Seat7> seats) {
        this.seats = seats;
    }
}
