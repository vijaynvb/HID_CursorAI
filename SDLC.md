1. Requirements 
    input: B2B or B2C
    output: BRD, SOW
    cursor role: Model?
2. High Level Design 
    input: BRD, SOW
    output: High Level Design 
        - Architecture
        - Components
        - Technologies
        - Data Flow
        - Security
        - Performance
        - Scalability
        - Availability
        - Disaster Recovery
    cursor role: Model?
3. Low Level Design 
    input: High Level Design
    output: Low Level Design
        - code
        - configuration
        - data
        - unit tests
        - containerization
        - IAC 
        - CI/CD pipelines
4. Testing 
    input: Low Level Design
    output: Testing
        - integration tests
        - system tests
        - performance tests (load tests, stress tests, etc.)
        - security tests (penetration tests, etc.)
        - compliance tests (regulatory tests, etc.)
5. Deployment
    k8s deployment
6. Monitoring 
    - sidecar pattern 
