# Tasty Food Restaurant - Next.js Menu Application

A beautiful restaurant menu application built with Next.js, featuring a dark chalkboard theme with orange and yellow accents.

## Features

- Dark chalkboard background with texture
- Responsive design for all screen sizes
- Menu categories: Appetizers, Main Courses, Desserts, and Drinks
- Circular food images with yellow borders
- Promotional offer section with free delivery and discount
- Modern UI with orange and yellow accent colors

## Getting Started

First, install the dependencies:

```bash
npm install
# or
yarn install
# or
pnpm install
```

Then, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Project Structure

```
webapp/
├── app/
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Main page
│   ├── page.module.css     # Page styles
│   └── globals.css         # Global styles
├── components/
│   ├── Header.tsx          # Restaurant header component
│   ├── Header.module.css
│   ├── MenuCategory.tsx    # Menu category component
│   ├── MenuCategory.module.css
│   ├── MenuItem.tsx        # Individual menu item component
│   ├── MenuItem.module.css
│   ├── PromotionalOffer.tsx # Promotional section component
│   ├── PromotionalOffer.module.css
│   ├── FoodImage.tsx       # Circular food image component
│   └── FoodImage.module.css
└── package.json
```

## Customization

You can customize the menu items by editing the `menuData` object in `app/page.tsx`. Replace the placeholder images with your own food images by updating the `foodImage1`, `foodImage2`, and `foodImage3` variables.

## Build for Production

```bash
npm run build
npm start
```

## Technologies Used

- Next.js 14
- React 18
- TypeScript
- CSS Modules
