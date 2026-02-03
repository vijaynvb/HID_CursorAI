import React from 'react';
import MenuItem from './MenuItem';
import styles from './MenuCategory.module.css';

interface MenuItemData {
  name: string;
  price: number;
  description?: string;
}

interface MenuCategoryProps {
  title: string;
  items: MenuItemData[];
  bannerDirection?: 'left' | 'center' | 'right';
  hasBorder?: boolean;
  isDrinks?: boolean;
}

const MenuCategory: React.FC<MenuCategoryProps> = ({
  title,
  items,
  bannerDirection = 'center',
  hasBorder = false,
  isDrinks = false,
}) => {
  return (
    <div className={`${styles.categoryContainer} ${hasBorder ? styles.bordered : ''} ${isDrinks ? styles.drinksContainer : ''}`}>
      <div className={`${styles.banner} ${styles[bannerDirection]}`}>
        <h2 className={styles.categoryTitle}>{title}</h2>
      </div>
      <div className={isDrinks ? styles.drinksGrid : styles.itemsList}>
        {items.map((item, index) => (
          <MenuItem
            key={index}
            name={item.name}
            price={item.price}
            description={item.description}
          />
        ))}
      </div>
    </div>
  );
};

export default MenuCategory;
