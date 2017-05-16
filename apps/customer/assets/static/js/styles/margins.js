const xxSmall = '5px';
const xSmall = '10px';
const small = '20px';
const medium = '30px';
const large = '40px';
const xLarge = '50px';
const xxLarge = '100px';

export default function (type) {
  switch (type) {
    case 'margin-left-xx-small':
      return `
        margin-left: ${xxSmall};
      `;
  }
}
