package erdiagram;

/**
 * Customer class representing a customer in the ordering system.
 */
public class Customer {
    private String name;
    private String address;
    private String creditRating;

    // Default constructor
    public Customer() {
    }

    // Constructor with parameters
    public Customer(String name, String address, String creditRating) {
        this.name = name;
        this.address = address;
        this.creditRating = creditRating;
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCreditRating() {
        return creditRating;
    }

    public void setCreditRating(String creditRating) {
        this.creditRating = creditRating;
    }

    @Override
    public String toString() {
        return "Customer{" +
                "name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", creditRating='" + creditRating + '\'' +
                '}';
    }
}
