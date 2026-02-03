package usecase_diagram.dto;

import java.util.ArrayList;
import java.util.List;

/**
 * Request DTO for creating a new order.
 */
public class CreateOrderRequest {
    private Long customerId;
    private Boolean isPrepaid;
    private List<OrderLineRequest> orderLines = new ArrayList<>();
    
    // Constructors
    public CreateOrderRequest() {
    }
    
    // Getters and Setters
    public Long getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }
    
    public Boolean getIsPrepaid() {
        return isPrepaid;
    }
    
    public void setIsPrepaid(Boolean isPrepaid) {
        this.isPrepaid = isPrepaid;
    }
    
    public List<OrderLineRequest> getOrderLines() {
        return orderLines;
    }
    
    public void setOrderLines(List<OrderLineRequest> orderLines) {
        this.orderLines = orderLines;
    }
    
    /**
     * Inner class for order line request.
     */
    public static class OrderLineRequest {
        private Long productId;
        private Integer quantity;
        
        public OrderLineRequest() {
        }
        
        public Long getProductId() {
            return productId;
        }
        
        public void setProductId(Long productId) {
            this.productId = productId;
        }
        
        public Integer getQuantity() {
            return quantity;
        }
        
        public void setQuantity(Integer quantity) {
            this.quantity = quantity;
        }
    }
}
