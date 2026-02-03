package erdiagram;

/**
 * CorporateCustomer class representing a corporate customer.
 * Extends the Customer class.
 */
public class CorporateCustomer extends Customer {
    private String contactName;
    private String creditRating;
    private double creditLimit;

    // Default constructor
    public CorporateCustomer() {
        super();
    }

    // Constructor with parameters
    public CorporateCustomer(String name, String address, String creditRating, 
                             String contactName, double creditLimit) {
        super(name, address, creditRating);
        this.contactName = contactName;
        this.creditRating = creditRating;
        this.creditLimit = creditLimit;
    }

    // Methods
    public void remind() {
        // Implementation for sending a reminder to the corporate customer
        System.out.println("Reminder sent to corporate customer: " + getName() + 
                          " (Contact: " + contactName + ")");
    }

    // Getters and Setters
    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName;
    }

    public String getCreditRating() {
        return creditRating;
    }

    public void setCreditRating(String creditRating) {
        this.creditRating = creditRating;
        // Also update the parent's credit rating
        super.setCreditRating(creditRating);
    }

    public double getCreditLimit() {
        return creditLimit;
    }

    public void setCreditLimit(double creditLimit) {
        this.creditLimit = creditLimit;
    }

    @Override
    public String toString() {
        return "CorporateCustomer{" +
                "name='" + getName() + '\'' +
                ", address='" + getAddress() + '\'' +
                ", creditRating='" + creditRating + '\'' +
                ", contactName='" + contactName + '\'' +
                ", creditLimit=" + creditLimit +
                '}';
    }
}
