import styled from 'styled-components';
import fonts from 'styles/fonts';
import colors from 'styles/colors';


export const Wrapper = styled.article`

`;

export const Heading = styled.div`
  margin-bottom: 30px;
  padding-bottom: 10px;
  border-bottom: 1px solid ${colors.listBorderColor};
`;

export const CompanyWrapper = styled.div`
  display: flex;
  margin-top: 5px;
  ${fonts('font-medium')} 
  line-height: 1.4;
  color: ${colors.leadSentenceColor};
  word-wrap: break-word;
  padding-bottom: 15px;
`

export const CompanyItem = styled.div`
  margin-right: 10px;
`;

export const Detail = styled.div`
  font-size: 1.8rem;
  font-family: Georgia,Cambria,Times New Roman,Times,serif;
  font-size: 2.1rem;
  color: rgba(0,0,0,0.8);
  font-weight: 400;
  line-height: 1.58;
  letter-spacing: -.003em;  
`;

export const FavoriteButtonWrapper = styled.div`
  display: flex;
  justify-content: flex-end;
  margin-top: 15px;
`;