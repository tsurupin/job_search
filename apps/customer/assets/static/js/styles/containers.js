export default function (type) {
  switch (type) {
    case 'root':
      return `
        max-width: 740px;
        position: relative;
        margin: 0 auto;
        padding: 3rem;
      `;
  }
}
