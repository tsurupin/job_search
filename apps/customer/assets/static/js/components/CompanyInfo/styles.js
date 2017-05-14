import styled from 'styled-components';
import fonts from 'styles/fonts';
import colors from 'styles/colors';

export const Wrapper = styled.div`
  display: flex;
  margin-top: 5px;
  ${fonts('font-medium')} 
  line-height: 1.4;
  color: ${colors.leadSentenceColor};
  word-wrap: break-word;
  padding-bottom: 15px;
`;

export const Item = styled.div`
  margin-right: 10px;
`;
