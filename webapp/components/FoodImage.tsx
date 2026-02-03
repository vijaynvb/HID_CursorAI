import React from 'react';
import styles from './FoodImage.module.css';

interface FoodImageProps {
  src: string;
  alt: string;
  position: 'top-left' | 'top-right' | 'bottom-right';
}

const FoodImage: React.FC<FoodImageProps> = ({ src, alt, position }) => {
  return (
    <div className={`${styles.imageContainer} ${styles[position]}`}>
      <div className={styles.imageWrapper}>
        <div className={styles.outerBorder}>
          <div className={styles.innerBorder}></div>
          <div className={styles.imageCircle}>
            <img src={src} alt={alt} className={styles.image} />
          </div>
        </div>
      </div>
    </div>
  );
};

export default FoodImage;
