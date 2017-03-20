import styled from 'styled-components';
import fonts from 'styles/fonts';
import colors from 'styles/colors';

export default styled.div`
  composes: ${fonts(`font-small`)};
  display: block;
  text-align: center;
  opacity: 0.3;
  color: ${colors.leadSentenceColor};
`;