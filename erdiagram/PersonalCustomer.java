package erdiagram;

/**
 * PersonalCustomer class representing a personal customer.
 * Extends the Customer class.
 */
public class PersonalCustomer extends Customer {
    private String creditCardId;

    // Default constructor
    public PersonalCustomer() {
        super();
    }

    // Constructor with parameters
    public PersonalCustomer(String name, String address, String creditRating, String creditCardId) {
        super(name, address, creditRating);
        this.creditCardId = creditCardId;
    }

    // Getters and Setters
    public String getCreditCardId() {
        return creditCardId;
    }

    public void setCreditCardId(String creditCardId) {
        this.creditCardId = creditCardId;
    }

    @Override
    public String toString() {
        return "PersonalCustomer{" +
                "name='" + getName() + '\'' +
                ", address='" + getAddress() + '\'' +
                ", creditRating='" + getCreditRating() + '\'' +
                ", creditCardId='" + creditCardId + '\'' +
                '}';
    }
}
