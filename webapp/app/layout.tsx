import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Tasty Food Restaurant',
  description: 'Delicious meals and drinks',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
