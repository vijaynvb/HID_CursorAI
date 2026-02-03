package usecase_diagram.dto;

import usecase_diagram.models.Order;

/**
 * Request DTO for updating order status.
 */
public class UpdateOrderStatusRequest {
    private Order.OrderStatus status;
    
    // Constructors
    public UpdateOrderStatusRequest() {
    }
    
    public UpdateOrderStatusRequest(Order.OrderStatus status) {
        this.status = status;
    }
    
    // Getters and Setters
    public Order.OrderStatus getStatus() {
        return status;
    }
    
    public void setStatus(Order.OrderStatus status) {
        this.status = status;
    }
}
