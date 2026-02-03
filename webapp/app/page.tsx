'use client';

import React from 'react';
import Header from '@/components/Header';
import MenuCategory from '@/components/MenuCategory';
import PromotionalOffer from '@/components/PromotionalOffer';
import FoodImage from '@/components/FoodImage';
import styles from './page.module.css';

// Placeholder images - replace with actual food images
const foodImage1 = 'https://images.unsplash.com/photo-1615367423057-4fa07e997d92?w=400&h=400&fit=crop';
const foodImage2 = 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=400&fit=crop';
const foodImage3 = 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=400&fit=crop';

const menuData = {
  appetizers: [
    { name: 'Meal 1', price: 10, description: 'Lorem ipsum dolor sit amet.' },
    { name: 'Meal 2', price: 10, description: 'Lorem ipsum dolor sit amet.' },
    { name: 'Meal 3', price: 10, description: 'Lorem ipsum dolor sit amet.' },
  ],
  mainCourses: [
    { name: 'Meal 1', price: 10, description: 'Lorem ipsum dolor sit amet.' },
    { name: 'Meal 2', price: 10, description: 'Lorem ipsum dolor sit amet.' },
    { name: 'Meal 3', price: 10, description: 'Lorem ipsum dolor sit amet.' },
  ],
  desserts: [
    { name: 'Meal 1', price: 10, description: 'Lorem ipsum dolor sit amet.' },
    { name: 'Meal 2', price: 10, description: 'Lorem ipsum dolor sit amet.' },
    { name: 'Meal 3', price: 10, description: 'Lorem ipsum dolor sit amet.' },
  ],
  drinks: [
    { name: 'Drink 1', price: 5 },
    { name: 'Drink 2', price: 5 },
    { name: 'Drink 3', price: 5 },
    { name: 'Drink 1', price: 5 },
    { name: 'Drink 2', price: 5 },
    { name: 'Drink 3', price: 5 },
  ],
};

export default function Home() {
  return (
    <main className={styles.main}>
      {/* Chalkboard background texture */}
      <div className={styles.chalkboardBackground}></div>
      
      {/* Food Images */}
      <FoodImage src={foodImage1} alt="Appetizers" position="top-left" />
      <FoodImage src={foodImage2} alt="Desserts" position="top-right" />
      <FoodImage src={foodImage3} alt="Main Course" position="bottom-right" />
      
      {/* Header */}
      <Header />
      
      {/* Menu Grid */}
      <div className={styles.menuGrid}>
        <div className={styles.menuColumn}>
          <MenuCategory
            title="Appetizers"
            items={menuData.appetizers}
            bannerDirection="left"
          />
        </div>
        
        <div className={styles.menuColumn}>
          <div className={styles.borderedSection}>
            <MenuCategory
              title="Main Courses"
              items={menuData.mainCourses}
              bannerDirection="center"
              hasBorder={false}
            />
            <MenuCategory
              title="Drinks"
              items={menuData.drinks}
              bannerDirection="center"
              isDrinks={true}
            />
          </div>
        </div>
        
        <div className={styles.menuColumn}>
          <MenuCategory
            title="Desserts"
            items={menuData.desserts}
            bannerDirection="right"
          />
        </div>
      </div>
      
      {/* Promotional Offer */}
      <div className={styles.promotionalSection}>
        <PromotionalOffer />
      </div>
    </main>
  );
}
