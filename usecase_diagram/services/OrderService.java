package usecase_diagram.services;

import usecase_diagram.dto.*;
import usecase_diagram.models.*;
import usecase_diagram.repository.OrderRepository;
import usecase_diagram.repository.CustomerRepository;
import usecase_diagram.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Service class for Order operations.
 * Implements use cases: Place Order, Cancel Order, Manage Order, Change Order Status
 */
@Service
@Transactional
public class OrderService {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private CustomerRepository customerRepository;
    
    @Autowired
    private ProductRepository productRepository;
    
    /**
     * Place Order - Use Case: Place Order (Visitor)
     */
    public OrderDTO placeOrder(CreateOrderRequest request) {
        // Validate customer exists
        Customer customer = customerRepository.findById(request.getCustomerId())
            .orElseThrow(() -> new RuntimeException("Customer not found with id: " + request.getCustomerId()));
        
        // Create order
        Order order = new Order();
        order.setOrderNumber(generateOrderNumber());
        order.setCustomer(customer);
        order.setPrepaid(request.getIsPrepaid() != null ? request.getIsPrepaid() : false);
        order.setStatus(Order.OrderStatus.PENDING);
        order.setDateReceived(LocalDateTime.now());
        
        // Process order lines
        Double totalPrice = 0.0;
        for (CreateOrderRequest.OrderLineRequest lineRequest : request.getOrderLines()) {
            Product product = productRepository.findById(lineRequest.getProductId())
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + lineRequest.getProductId()));
            
            // Check stock availability
            if (product.getStockQuantity() < lineRequest.getQuantity()) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }
            
            OrderLine orderLine = new OrderLine();
            orderLine.setProduct(product);
            orderLine.setQuantity(lineRequest.getQuantity());
            orderLine.setUnitPrice(product.getPrice());
            order.addOrderLine(orderLine);
            
            totalPrice += orderLine.getLineTotal();
        }
        
        order.setTotalPrice(totalPrice);
        
        // Save order
        Order savedOrder = orderRepository.save(order);
        
        return convertToDTO(savedOrder);
    }
    
    /**
     * Cancel Order - Use Case: Cancel Order (Visitor, Admin)
     */
    public OrderDTO cancelOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));
        
        if (order.getStatus() == Order.OrderStatus.CANCELLED) {
            throw new RuntimeException("Order is already cancelled");
        }
        
        if (order.getStatus() == Order.OrderStatus.DELIVERED) {
            throw new RuntimeException("Cannot cancel a delivered order");
        }
        
        order.setStatus(Order.OrderStatus.CANCELLED);
        Order savedOrder = orderRepository.save(order);
        
        return convertToDTO(savedOrder);
    }
    
    /**
     * Manage Order - Use Case: Manage Order (Visitor, Admin)
     * Get order details
     */
    @Transactional(readOnly = true)
    public OrderDTO getOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));
        
        return convertToDTO(order);
    }
    
    /**
     * Manage Order - Get all orders for a customer (Visitor)
     */
    @Transactional(readOnly = true)
    public List<OrderDTO> getOrdersByCustomer(Long customerId) {
        List<Order> orders = orderRepository.findByCustomerId(customerId);
        return orders.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }
    
    /**
     * Manage Order - Get all orders (Admin)
     */
    @Transactional(readOnly = true)
    public List<OrderDTO> getAllOrders() {
        List<Order> orders = orderRepository.findAll();
        return orders.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }
    
    /**
     * Change Order Status - Use Case: Change Order Status (Admin)
     */
    public OrderDTO changeOrderStatus(Long orderId, UpdateOrderStatusRequest request) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));
        
        order.setStatus(request.getStatus());
        Order savedOrder = orderRepository.save(order);
        
        return convertToDTO(savedOrder);
    }
    
    /**
     * Get orders by status
     */
    @Transactional(readOnly = true)
    public List<OrderDTO> getOrdersByStatus(Order.OrderStatus status) {
        List<Order> orders = orderRepository.findByStatus(status);
        return orders.stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }
    
    // Helper methods
    private String generateOrderNumber() {
        return "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
    
    private OrderDTO convertToDTO(Order order) {
        OrderDTO dto = new OrderDTO();
        dto.setId(order.getId());
        dto.setOrderNumber(order.getOrderNumber());
        dto.setDateReceived(order.getDateReceived());
        dto.setIsPrepaid(order.isPrepaid());
        dto.setTotalPrice(order.getTotalPrice());
        dto.setStatus(order.getStatus());
        dto.setCreatedAt(order.getCreatedAt());
        dto.setUpdatedAt(order.getUpdatedAt());
        
        if (order.getCustomer() != null) {
            dto.setCustomerId(order.getCustomer().getId());
            dto.setCustomerName(order.getCustomer().getName());
        }
        
        if (order.getOrderLines() != null) {
            List<OrderLineDTO> lineDTOs = order.getOrderLines().stream()
                .map(line -> {
                    OrderLineDTO lineDTO = new OrderLineDTO();
                    lineDTO.setId(line.getId());
                    lineDTO.setQuantity(line.getQuantity());
                    lineDTO.setUnitPrice(line.getUnitPrice());
                    lineDTO.setLineTotal(line.getLineTotal());
                    if (line.getProduct() != null) {
                        lineDTO.setProductId(line.getProduct().getId());
                        lineDTO.setProductName(line.getProduct().getName());
                    }
                    return lineDTO;
                })
                .collect(Collectors.toList());
            dto.setOrderLines(lineDTOs);
        }
        
        return dto;
    }
}
