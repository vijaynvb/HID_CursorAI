package erdiagram;

/**
 * OrderLine class representing a line item in an order.
 */
public class OrderLine {
    private String product;
    private int quantity;
    private double price;
    private Order order;

    // Default constructor
    public OrderLine() {
    }

    // Constructor with parameters
    public OrderLine(String product, int quantity, double price) {
        this.product = product;
        this.quantity = quantity;
        this.price = price;
    }

    // Getters and Setters
    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public double getLineTotal() {
        return quantity * price;
    }

    @Override
    public String toString() {
        return "OrderLine{" +
                "product='" + product + '\'' +
                ", quantity=" + quantity +
                ", price=" + price +
                ", lineTotal=" + getLineTotal() +
                '}';
    }
}
