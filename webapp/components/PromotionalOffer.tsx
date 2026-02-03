import React from 'react';
import styles from './PromotionalOffer.module.css';

const PromotionalOffer: React.FC = () => {
  return (
    <div className={styles.promotionalContainer}>
      <div className={styles.orangeBox}>
        <div className={styles.deliveryIcon}>🛵</div>
        <p className={styles.deliveryText}>FREE DELIVERY</p>
        <div className={styles.discountCircle}>
          <span className={styles.discountNumber}>25</span>
          <span className={styles.discountPercent}>%</span>
          <span className={styles.discountOff}>OFF</span>
        </div>
      </div>
    </div>
  );
};

export default PromotionalOffer;
