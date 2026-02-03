package erdiagram;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Order class representing an order in the ordering system.
 */
public class Order {
    private Date dateReceived;
    private boolean isPrepaid;
    private String number;
    private double price;
    private Customer customer;
    private List<OrderLine> orderLines;

    // Default constructor
    public Order() {
        this.orderLines = new ArrayList<>();
    }

    // Constructor with parameters
    public Order(Date dateReceived, boolean isPrepaid, String number, double price, Customer customer) {
        this.dateReceived = dateReceived;
        this.isPrepaid = isPrepaid;
        this.number = number;
        this.price = price;
        this.customer = customer;
        this.orderLines = new ArrayList<>();
    }

    // Methods
    public void dispatch() {
        // Implementation for dispatching the order
        System.out.println("Order " + number + " has been dispatched.");
    }

    public void close() {
        // Implementation for closing the order
        System.out.println("Order " + number + " has been closed.");
    }

    // Getters and Setters
    public Date getDateReceived() {
        return dateReceived;
    }

    public void setDateReceived(Date dateReceived) {
        this.dateReceived = dateReceived;
    }

    public boolean isPrepaid() {
        return isPrepaid;
    }

    public void setPrepaid(boolean prepaid) {
        isPrepaid = prepaid;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public List<OrderLine> getOrderLines() {
        return orderLines;
    }

    public void setOrderLines(List<OrderLine> orderLines) {
        this.orderLines = orderLines;
    }

    public void addOrderLine(OrderLine orderLine) {
        if (orderLine != null) {
            this.orderLines.add(orderLine);
            orderLine.setOrder(this);
        }
    }

    public void removeOrderLine(OrderLine orderLine) {
        if (orderLine != null) {
            this.orderLines.remove(orderLine);
            orderLine.setOrder(null);
        }
    }

    @Override
    public String toString() {
        return "Order{" +
                "dateReceived=" + dateReceived +
                ", isPrepaid=" + isPrepaid +
                ", number='" + number + '\'' +
                ", price=" + price +
                ", customer=" + (customer != null ? customer.getName() : "null") +
                ", orderLinesCount=" + orderLines.size() +
                '}';
    }
}
