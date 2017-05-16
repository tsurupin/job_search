export default function (type) {
  switch (type) {
    case 'font-xx-small':
      return `
         font-size: 10px;
         font-size: 1.0rem;
      `;
    case 'font-x-small':
      return `
        font-size: 12px;
        font-size: 1.2rem;
      `;
    case 'font-small':
      return `
        font-size: 14px;
        font-size: 1.4rem;
      `;
    case 'font-medium':
      return `
        font-size: 16px;
        font-size: 1.6rem;
      `;
    case 'font-large':
      return `
         font-size: 18px;
         font-size: 1.8rem;
      `;
    case 'font-x-large':
      return `
        font-size: 20px;
        font-size: 2.1rem;
      `;
    case 'font-description':
      return `
        font-size: 21px;
        font-size: 2.1rem;
      `;
    case 'font-xx-large':
      return `
        font-size: 24px;
        font-size: 2.4rem;
      `;
    case 'font-title':
      return `
        font-size: 28px;
        font-size: 2.8rem;
      `;
    case 'font-heading':
      return `
        font-size: 32px;
        font-size: 3.2rem;
      `;
  }
}
