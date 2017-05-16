import styled from 'styled-components';
import fonts from 'styles/fonts';
import colors from 'styles/colors';

export default styled.p`
  margin-top: 5px;
  ${fonts('font-medium')} 
  line-height: 1.4;
  color: ${colors.leadSentenceColor};
  word-wrap: break-word;
  padding-bottom: 15px;
`;
