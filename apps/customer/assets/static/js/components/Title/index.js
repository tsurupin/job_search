import styled from 'styled-components';
import colors from 'styles/colors';
import fonts from 'styles/fonts';

export default styled.h3`
  ${fonts('font-title')}
  line-height: 1.12;
  color: ${colors.textColor};
  letter-spacing: -.022em;
  font-weight: 700;
`;
