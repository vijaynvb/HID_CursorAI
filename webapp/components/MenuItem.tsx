import React from 'react';
import styles from './MenuItem.module.css';

interface MenuItemProps {
  name: string;
  price: number;
  description?: string;
}

const MenuItem: React.FC<MenuItemProps> = ({ name, price, description }) => {
  return (
    <div className={styles.menuItem}>
      <div className={styles.itemHeader}>
        <h3 className={styles.itemName}>{name}</h3>
        <span className={styles.itemPrice}>{price} $</span>
      </div>
      {description && (
        <p className={styles.itemDescription}>{description}</p>
      )}
    </div>
  );
};

export default MenuItem;
