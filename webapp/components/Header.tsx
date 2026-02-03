import React from 'react';
import styles from './Header.module.css';

const Header: React.FC = () => {
  return (
    <header className={styles.header}>
      <div className={styles.logoContainer}>
        <div className={styles.logoCircle}>
          <div className={styles.logoIcon}>🍜</div>
        </div>
        <p className={styles.logoText}>YOUR LOGO</p>
      </div>
      <div className={styles.titleContainer}>
        <h1 className={styles.restaurantName}>Tasty Food</h1>
        <h2 className={styles.restaurantSubtitle}>RESTAURANT</h2>
      </div>
    </header>
  );
};

export default Header;
